From: tytso@mit.edu
Subject: Re: nolazytime remount
Date: Wed, 19 Aug 2015 14:15:16 +0000
Message-ID: <20150819141516.GD8806@thunk.org>
References: <20150819082144.GB1689@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37483 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbbHSOPR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2015 10:15:17 -0400
Content-Disposition: inline
In-Reply-To: <20150819082144.GB1689@ws.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 19, 2015 at 10:21:44AM +0200, Karel Zak wrote:
> 
> It seems that ext4_remount() allows to enable the option by MS_LAZYTIME,
> but there is no sb->s_flags &= ~MS_LAZYTIME at all. It seems like a
> regression, because old string based solution (handle_mount_opt()) contains:
> 
>   case Opt_nolazytime:
>        sb->s_flags &= ~MS_LAZYTIME;
>        return 1;
> 
> 
> From my point of view, a2fd66d06 commit is insufficient, for ext4_remount()
> we also need "else" for MS_LAZYTIME:
> 
> 	if (*flags & MS_LAZYTIME)
> 		sb->s_flags |= MS_LAZYTIME;
>     else
>         sb->s_flags &= ~MS_LAZYTIME;
> 
> 
> The another possibility is that "lazytime" is possible enable only --
> if yes, then handle_mount_opt() should be fixed to not provide
> Opt_nolazytime.

Yeah, I noticed this when I coded up a2fd66d06, but the problem is
that if you are using an older version of mount, then a command which
does *not* mention lazytime will silently ending up disabling
lazttime.  (This a generic problem any time we migrate whether mount
program or the kernel is supposed to parse a particular mount option
where we toggle state by the presence or absence of a MS_XXX bit; so
we could also solve this problem by burning another mount option bit
for MS_NOLAZYTIME, but we don't have any bits left.)

So the question is which is worse.  Causing people who are using newer
kernels, but older versions of mount, and who want to use lazytime, to
have to specify it on every single "mount -o remount" command (and
this includes someone who sets lazytime using rootflags, and now needs
to start hacking systemd binaries since there is no longer a shell
program to remount file systems read-write --- why I hate systemd, but
that's a rant for another forum), or make it impossible for people who
are using newer versions of mount who want to disable lazytime.

I *think* the number of people who would want to disable lazytime is
smaller, which why I made the decision that I did, so my thinking was
to leave it this way until the next version of Debian stable ships,
and then change the kernel to allow the newer versions of mount to
disable lazytime at that point.

I suppose I could set up make this be switchable, so people could
specify ext4.support_older_mount=1 on the boot command-line option,
but this seems really ugly, and then people would need to remember to
remove said ugly command-line option from their grub config file when
they update to a newer mount command.

Blargh; no really good solutions here.  Does anyone have any thoughts
or suggestions about how to handle this better?

   	       	     	    	   	- Ted
