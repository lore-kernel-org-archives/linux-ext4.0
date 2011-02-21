From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: enable acls and user_xattr by default
Date: Mon, 21 Feb 2011 11:10:16 -0600
Message-ID: <4D629C78.60600@redhat.com>
References: <4D5ED705.7010902@redhat.com> <20110221134642.GC6584@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1BURKV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Feb 2011 12:10:21 -0500
In-Reply-To: <20110221134642.GC6584@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/21/11 7:46 AM, Jan Kara wrote:
>   Hi Eric,
> 
> On Fri 18-02-11 14:31:01, Eric Sandeen wrote:
>> There's no good reason to require the extra step of providing
>> a mount option for acl or user_xattr once the feature is configured
>> on; no other filesystem that I know of requires this.
>>
>> Userspace patches have set these options in default mount options,
>> and this patch makes them default in the kernel.  At some point
>> we can start to deprecate the options, perhaps.
>>
>> For now I've removed default mount option checks in show_options()
>> to be explicit about what's set, since it's changing the default,
>> but I'm open to alternatives if desired.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> p.s. I've got ext2 & ext3 patches too - Jan, is this ok with
>> you for ext2/3 as well?
>   I was thinking about this for a while. I definitely agree with the change
> of default mount options in e2fsprogs (so that user_xattr and acl will be
> turned on by default). But after such change is there really any bigger
> point in changing the kernel defaults? Users won't have to specify options
> for new filesystems because of new default mount options setting (so the
> change does not bring any simplification) and for old filesystems the admin
> has proper options in /etc/fstab and if not perhaps he didn't want e.g.
> user_xattr to be supported so suddently turning the support on with newer
> kernel will confuse them)?

Well, I did this initially because Ted & Andreas seemed to want it ;)

I think the idea is, we should move to deprecating and removing the options
altogether.  Is there any advantage to having them?  And the first step
to deprecating them might be to change the default.

It does seem a little odd to now have the default one way in userspace,
and another way in the kernel.

But I'm OK either way, to be honest.  Userspace alone solves my "Fedora
Problem" but it leaves the kernel as kind of an oddball.

-Eric

> So if we wanted to do such a transition for consistency with other
> filesystems, we should maybe first start warning that people should use
> nouser_xattr and noacl when they really didn't want them?


 
> 								Honza

