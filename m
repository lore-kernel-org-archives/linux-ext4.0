From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Date: Tue, 06 Nov 2007 10:04:47 -0800
Message-ID: <4730ACBF.6050606@zytor.com>
References: <20071106171537.GD23689@duck.suse.cz>	<20071106171945.GG23689@duck.suse.cz> <20071106094056.3352a574@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:46669 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbXKFSIN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Nov 2007 13:08:13 -0500
In-Reply-To: <20071106094056.3352a574@laptopd505.fenrus.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 6 Nov 2007 18:19:45 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
>> Implement recursive mtime (rtime) feature for ext3. The feature works
>> as follows: In each directory we keep a flag EXT3_RTIME_FL
>> (modifiable by a user) whether rtime should be updated. In case a
>> directory or a file in it is modified and when the flag is set,
>> directory's rtime is updated, the flag is cleared, and we move to the
>> parent. If the flag is set there, we clear it, update rtime and
>> continue upwards upto the root of the filesystem. In case a regular
>> file or symlink is modified, we pick arbitrary of its parents
>> (actually the one that happens to be at the head of i_dentry list)
>> and start the rtime update algorith there.
> 
> Ok since mtime (and rtime) are part of the inode and not the dentry...
> how do you deal with hardlinks? And with cases of files that have been
> unlinked? (ok the later is a wash obviously other than not crashing)
> 

There is only one possible answer... he only updates the directory path 
that was used to touch the particular file involved.  Thus, the 
semantics gets grotty not just in the presence of hard links, but also 
in the presence of bind- and other non-root mounts.

	-hpa
