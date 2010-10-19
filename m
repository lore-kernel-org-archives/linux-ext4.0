From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/2] ext3: Avoid uninitialized memory references with a corrupted htree directory
Date: Tue, 19 Oct 2010 01:12:27 -0600
Message-ID: <DA809C60-6201-4A3D-8996-9AA74B9E4DFD@dilger.ca>
References: <20101016233513.GA31722@thunk.org> <1287272220-1591-1-git-send-email-tytso@mit.edu> <20101018100515.GB3826@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Brad Spengler <spender@grsecurity.net>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:30006 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab0JSHM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Oct 2010 03:12:29 -0400
In-Reply-To: <20101018100515.GB3826@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-18, at 04:05, Jan Kara wrote:
> On Sat 16-10-10 19:36:59, Theodore Ts'o wrote:
>> @@ -871,6 +872,16 @@ static struct buffer_head *ext3_find_entry(struct inode *dir,
>> 	namelen = entry->len;
>> 	if (namelen > EXT3_NAME_LEN)
>> 		return NULL;
>> +	if ((namelen < 2) && (name[0] == '.') &&
>> +	    (name[1] == '.' || name[1] == '0')) {
> 
> This condition looks wrong... I suspect it should rather be:
> (namelen <= 2) && (name[0] == '.') && (name[1] == '.' || name[1] == 0)
>      ^^^ change here                                  and here ^^^

I think it is preferable to use '\0' for the trailing NUL.

Cheers, Andreas
