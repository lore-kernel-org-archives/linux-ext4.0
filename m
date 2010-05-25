From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after transaction restart
Date: Tue, 25 May 2010 18:28:29 +0400
Message-ID: <87632ckqcy.fsf@openvz.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
	<20100525133241.GF5556@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com, tytso@mit.ed
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45693 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228Ab0EYO2f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 10:28:35 -0400
Received: by bwz7 with SMTP id 7so1276613bwz.19
        for <linux-ext4@vger.kernel.org>; Tue, 25 May 2010 07:28:33 -0700 (PDT)
In-Reply-To: <20100525133241.GF5556@thunk.org> (tytso@mit.edu's message of
	"Tue, 25 May 2010 09:32:41 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Thu, Apr 22, 2010 at 08:31:11AM +0400, Dmitry Monakhov wrote:
>> @@ -2480,6 +2480,11 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
>>  out:
>>  	ext4_ext_drop_refs(path);
>>  	kfree(path);
>> +	if (err == EAGAIN) {
>
> Surely this should be "err == -EAGAIN", no?  I'm curious how this
> patch worked for with this typo....
As usually it fix one thing, and broke another :(.
So in case of alloc/truncate restart truncate will be aborted,
so i_size != i_disk_size which must be caught by fsck (my test run
it every time) but this never happens which is very strange.
The only reason i can explain this that truncate was called second
time which is probable due to should_retry_alloc logic.
Even more than this, i've changed the mistypo and have got massive
complain from fsck
Block bitmap differences:  -7954 -(33836--33854)
Fix<y>? yes

Free blocks count wrong for group #0 (24170, counted=24171).
Fix<y>? yes
...
Currently i'm digging the issue.

>
>> +		err = 0;
>> +		goto again;
>> +	}
>> +	ext4_clear_inode_state(inode, EXT4_STATE_EXT_TRUNC);
>>  	ext4_journal_stop(handle);
>>  
>>  	return err;
>
> 					- Ted
