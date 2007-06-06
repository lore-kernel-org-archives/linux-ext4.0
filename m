From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/1] e2fsprogs: Add undo I/O manager.
Date: Wed, 06 Jun 2007 15:32:27 +0530
Message-ID: <46668633.7060403@linux.vnet.ibm.com>
References: <4c7823c85d4ea3b4535f9fc0e4afa93078317f81.1179828850.git.aneesh.kumar@linux.vnet.ibm.com> <20070603231701.GA10140@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:44627 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786AbXFFKDx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jun 2007 06:03:53 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l56A5HaO8134732
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jun 2007 20:05:22 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l56A72lX050766
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jun 2007 20:07:15 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l56A39sr029104
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jun 2007 20:03:09 +1000
In-Reply-To: <20070603231701.GA10140@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Tso wrote:
> On Tue, May 22, 2007 at 03:47:33PM +0530, Aneesh Kumar K.V wrote:
>> This I/O manager saves the contents of the location being overwritten
>> to a tdb database. This helps in undoing the changes done to the
>> file system.
>>
>> +	/* loop through the existing entries and find if they overlap */
>> +	for (key = tdb_firstkey(tdb); key.dptr; key = tdb_nextkey(tdb, key)) {
>> +		data = tdb_fetch(tdb, key);
>> +		/*
>> +		 * we are not interested in the data
>> +		 */
>> +		free(data.dptr);
> 
> Youch.  This is going to be painful; it means that for every single
> write, we need to iterate over every single entry in the TDB.  This
> doesn't scale terribly well.  :-(
> 
> I suspect you will do much better by using a different encoding for
> the tdb database; namely, one where you don't use an extent-based
> encoding, but rather something which is strictly block based.  So that
> means a separate entry in the tdb database for each block entry.  That
> will be slightly more inefficient in terms of overhead stored in the
> tdb database, yes, but as a percentage of the blocksize (typically
> 4k), the overhead isn't that great, and the performance improvement
> will be huge.
> 
> The downside of doing this is that you need to take into account
> changes in blocksize via set_blksize() (this is rare; it's only done
> by mke2fs, and then only to zap various MD superblocks, et. al), and
> if the size is negative (in which case it represents the size in
> bytes, which could be more or less than a blocksize, and not
> necessarily a multiple of a blocksize).
> 


If we allow to change the block size in between that would mean the
records that we store in the tdb database will be of variable size ( 
different block sizes). That would also add all the code/complexity that 
i have in is_trans_overlapping. So if we are looking at avoiding the 
above for() loop then we should have constant block size (4K ?).  But in 
your above statement, you are counting overhead as a percentage of 
blocksize. So how do we handle this ?


Now with constant block size The write_blk gets complex because of there 
won't be a 1:1 mapping between the block number we need to use in 
tdb_database and the backing I/O manager.




> But that's not too bad, since now you just have to do is figure out
> which block(s) need to be saved, and then check to see if a record
> already exists in the tdb; if it does, the original value has been
> saved, and you don't have to do anything; if it doesn't then you just
> save the entire block.  The undo manager need to save the first
> blocksize specified, and backup the original data in the tdb file in
> terms of that first blocksize, regardless of any later changes in the
> blocksize (which as I said is rare).
> 

>> +		if (req_loc < cur_loc) {
>> +			if (req_loc+req_size > cur_loc) {
>> +				/*  ------------------
>> +				 *  |      |    |    |
>> +				 *  ------------------
>> +				 *  rl     cl   rs   cs
>> +				 */
> 
> This looks like notes to yourself; but it's not obvious what's going
> on here.  Fortunately with the above suggested change in algorith,
> most of this will go away, but please make your comments more obvious.
> 


rl -> req_loc
cl -> cur_loc
rs -> req_size
cs -> cur_size




>> +	// I have libtdb1. Enable after rebasing to latest e2fsprogs that has this API
>> +	//tdb_transaction_start(data->tdb);
> 
> What version of e2fsprogs are you developing against?
> 


Right now i am manually linking it against libtdb.

dpkg --search /usr/lib/libtdb.so
tdb-dev: /usr/lib/libtdb.so



>> +		/* FIXME!! Not sure what should be the error */
>> +		//tdb_transaction_cancel(data->tdb);
>> +		retval = EXT2_ET_SHORT_WRITE;
>> +		goto error_out;
> 
> I would add a new error code in lib/ext2fs/ext2_err.et.in; that way we
> can have a very specific error code explaining that we have a failure
> to save the original version of the block.  
> 


Will do this


>> +       actual = read(data->dev, tdb_data.dptr, size);
>> +       if (actual != size) {
> 
> Instead of using ext2fs_llseek() and read(), please use the underlying
> io_manager.  That way the undo manager might have a chance to work on
> some other io manager other than unix_io.  Yes, that means that you
> might in some cases need to save and restore the current blksize.  But
> that's not going to be the common case, and it will make the code much
> more general.
> 
>> +error_out:
>> +	/* Move the location back */
>> +	if (ext2fs_llseek(data->dev, cur_loc, SEEK_SET) != cur_loc) {
>> +		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
>> +		goto error_out;
>> +	}
> 
> Why do you need to move the location back?  As far as I know nothing
> should be depending on current offset of the file descriptor.
> 
>

No specific reason.


-aneesh
