From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: don't give the "disabling delalloc" if not explicitly
 specified
Date: Mon, 15 Aug 2011 15:04:26 -0500
Message-ID: <4E497BCA.4030300@redhat.com>
References: <1313290358-12611-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1108151134280.3695@dhcp-27-109.brq.redhat.com> <4E494246.2050609@redhat.com> <20110815175426.GB5948@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab1HOUE3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 16:04:29 -0400
In-Reply-To: <20110815175426.GB5948@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/15/11 12:54 PM, Ted Ts'o wrote:
> On Mon, Aug 15, 2011 at 10:59:02AM -0500, Eric Sandeen wrote:
>>
>> The giant behavior-options switch in ext4 is confusing enough; if enabling
>> one option disables another default option, I think that explicitly stating
>> it in the logs is useful.  Doing so silently just covers up the behavior.
>>
>> If users are unhappy with the message, it's probably more because of 
>> the fact of the matter, and not because of the presentation of the fact.  :)
> 
> Most users probably have no idea what "delalloc" actually means.  So
> when they get a message that saying that data=journalled has disabled
> delalloc, it could easily be seen as noise.  I was moved to do it
> because I got tired of seeing the message over, and over, and over
> again when running xfstests.
> 
> Maybe an improvement would be (1) to document what data=journal
> implies in the Documentation/filesystems/ext4.txt, (2) change the
> message to explicitly say "delayed allocation" instead of "delalloc"
> (although many people won't have any idea what "delayed allocation"
> means either), and (3) make it a printk_once thing.
> 
> I guess I don't agree with the fundamental presumption which is that
> users should be looking at the dmesg output to understand what various
> things mean, and if they didn't explicitly specify delalloc, why
> should we complain about the fact that both delalloc and data=journal
> were specified (when in fact it wasn't specified).

Well, just my $0.02, I won't fight it.

One thing I do want, though, is to be able to look at logs and know
what mode we're running in.  I guess we do print all specified options,
so those in the know, will know that delalloc is off if data=journal is on.

But I think we could use some consistency here at least:

[root@inode ~]# mount -o data=journal,dioread_nolock /dev/sdb5 /mnt/test
[root@inode ~]#  /* YAY it worked! */

[root@inode ~]# dmesg | tail
...
[269530.183245] EXT4-fs (sdb5): Ignoring delalloc option - requested data journaling mode
[269530.191170] EXT4-fs (sdb5): Ignoring dioread_nolock option - requested data journaling mode

/* boo it didn't work */

Better hit that one too, I guess, and any other option which disables
another default ...  (honestly, I think it'd be better to fail the mount
in cases like this if conflicting options are specified).

-Eric


-Eric
