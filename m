From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/1] Fix of coding style
Date: Mon, 26 Jan 2015 18:28:19 +0100
Message-ID: <54C67933.5050304@suse.cz>
References: <BLU436-SMTP226247403551FD98C6991B7D9350@phx.gbl> <54C676FE.2060400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: Eric Sandeen <sandeen@redhat.com>,
	Jan Mrazek <email@honzamrazek.cz>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	trivial@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48143 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbbAZR2X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2015 12:28:23 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so11591943wiv.0
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jan 2015 09:28:21 -0800 (PST)
In-Reply-To: <54C676FE.2060400@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/26/2015, 06:18 PM, Eric Sandeen wrote:
> On 1/26/15 10:24 AM, Jan Mrazek wrote:
>> - multiline strings changed to singleline (so it can be greped)
> 
> Thereby blowing past 80 columns in many cases, something we generally
> don't like to do, per Documentation/CodingStyle:

When you refer to that document, you certainly read the whole chapter 2 :).

>> The limit on the length of lines is 80 columns and this is a strongly
>> preferred limit.
> 
> I'm not so sure about the grep-ability value, because nobody's going to
> grep for "...%s): %s:%d: inode #%lu: ..." anyway...

Perhaps, but
  grep EXT4.*block.*comm
does the trick quite nice... And this is actually a nice example of the
point of this exercise.

> but if it's really deemed desirable to keep these strings on one line,
> we could do i.e.:
> 
>> +			printk(KERN_CRIT
>> +"EXT4-fs error (device %s): %s:%d: inode #%lu: block %llu: comm %s: %pV\n",
>>  			       inode->i_sb->s_id, function, line, inode->i_ino,
>>  			       block, current->comm, &vaf)
> 
> which is a trick the xfs code uses in some places.

Oh no, that's ugly. If anything, this could have been pr_crit("EXT4-fs
error ...

thanks,
-- 
js
suse labs
