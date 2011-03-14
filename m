From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Large directories and poor order correlation
Date: Mon, 14 Mar 2011 16:12:49 -0500
Message-ID: <4D7E84D1.5010504@redhat.com>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com> <4D7E8005.4030201@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1CNVMy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Mar 2011 17:12:54 -0400
In-Reply-To: <4D7E8005.4030201@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/14/11 3:52 PM, Phillip Susi wrote:
> On 3/14/2011 4:37 PM, Eric Sandeen wrote:
>> On 3/14/11 3:24 PM, Phillip Susi wrote:
>>> Shouldn't copying or extracting or otherwise populating a large
>>> directory of many small files at the same time result in a strong
>>> correlation between the order the names appear in the directory, and the
>>> order their data blocks are stored on disk, and thus, read performance
>>> should not be negatively impacted by fragmentation?
>>
>> No, because htree (dir_index) dirs returns names in hash-value
>> order, not inode number order.  i.e. "at random."
> 
> I thought that the htree was used to look up names, but the normal
> directory was used to enumerate them?  In other words, the htree speeds
> up opening a single file, but slows down traversing the entire
> directory, so should not be used there.

readdir uses htree / dir_index:

ext3_readdir()
        if (EXT3_HAS_COMPAT_FEATURE(inode->i_sb,
                                    EXT3_FEATURE_COMPAT_DIR_INDEX) &&
            ((EXT3_I(inode)->i_flags & EXT3_INDEX_FL) ||
             ((inode->i_size >> sb->s_blocksize_bits) == 1))) {
                err = ext3_dx_readdir(filp, dirent, filldir);

Because dir_index places entries into blocks in hash order, reading
it "like a non-dir_index" dir still gives you out of order entries,
I think.  IOW it doesn't slow down readdir, it just gives you a nasty
order - slowing down access to those files.

> Also isn't htree only enabled for large directories?  I still see crummy
> correlation for small ( < 100 files, even one with only 8 entries )
> directories.

Nope, it's used for all directories AFAIK.  Certainly shows the most
improvement on lookups in large directories though...

> It seems unreasonable to ask applications to read all directory entries,
> then sort them by inode number to achieve reasonable performance.  This
> seems like something the fs should be doing.

Yeah, this has been a longstanding nastiness...

-Eric
