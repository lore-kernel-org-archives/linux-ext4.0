From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: enable acls and user_xattr by default
Date: Mon, 21 Feb 2011 14:46:42 +0100
Message-ID: <20110221134642.GC6584@quack.suse.cz>
References: <4D5ED705.7010902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab1BUNqw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Feb 2011 08:46:52 -0500
Content-Disposition: inline
In-Reply-To: <4D5ED705.7010902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Eric,

On Fri 18-02-11 14:31:01, Eric Sandeen wrote:
> There's no good reason to require the extra step of providing
> a mount option for acl or user_xattr once the feature is configured
> on; no other filesystem that I know of requires this.
> 
> Userspace patches have set these options in default mount options,
> and this patch makes them default in the kernel.  At some point
> we can start to deprecate the options, perhaps.
> 
> For now I've removed default mount option checks in show_options()
> to be explicit about what's set, since it's changing the default,
> but I'm open to alternatives if desired.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> p.s. I've got ext2 & ext3 patches too - Jan, is this ok with
> you for ext2/3 as well?
  I was thinking about this for a while. I definitely agree with the change
of default mount options in e2fsprogs (so that user_xattr and acl will be
turned on by default). But after such change is there really any bigger
point in changing the kernel defaults? Users won't have to specify options
for new filesystems because of new default mount options setting (so the
change does not bring any simplification) and for old filesystems the admin
has proper options in /etc/fstab and if not perhaps he didn't want e.g.
user_xattr to be supported so suddently turning the support on with newer
kernel will confuse them)?

So if we wanted to do such a transition for consistency with other
filesystems, we should maybe first start warning that people should use
nouser_xattr and noacl when they really didn't want them?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
