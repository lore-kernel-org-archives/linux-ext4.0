From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Wed, 29 Apr 2009 16:54:58 -0400
Message-ID: <20090429205458.GA24749@mit.edu>
References: <20090224084434.GF6020@nb.net.home> <20090324121147.GA22386@zelda.netsplit.com> <20090416102241.GA3290@nb.net.home> <1239976118.11603.109.camel@quest> <20090422133304.GP15541@mit.edu> <1240407745.2902.3.camel@wing-commander> <20090422134945.GQ15541@mit.edu> <1241025728.16780.21.camel@quest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karel Zak <kzak@redhat.com>, linux-ext4@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
To: Scott James Remnant <scott@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57792 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbZD2UzF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 16:55:05 -0400
Content-Disposition: inline
In-Reply-To: <1241025728.16780.21.camel@quest>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Scott, thanks for submitting these patches.   Two quick comments:

1) It's greatly preferred if you submit each patch as separate e-mail
messages, with the one-line summary as the subject (as you might find
in a git submission or as described in sections 5.4 and 5.5 in the file
Documentation/development-process/5.Posting in the Linux kernel sources).
The reason for this is that the patchs will then be tracked in patchwork:

    http://patchwork.ozlabs.org/project/linux-ext4/list/

and if it's accurately reflected there, it's much less likely that I
won't accidentally forget to act on your patches, especially when I
get busy/overloaded.  The best thing to do is to use "git
format-patch" (which you apparenlty did to generate the patch), and
then use "git send-email" to send out the patches.

I find that this is in fact the fastest way for me to do work.  So
after I commit two patches, I'll do something like this:

rm -rf /tmp/p
git format-patch -n -o /tmp/p -2
git send-email --to linux-ext4@vger.kernel.org /tmp/p

(and in fact I have an aliases file configured in ~/.gitconfig, so I
have sendemail.aliasesfile=/home/tytso/.mutt/aliases and
sendemail.aliasfiletype=mutt, in which case all I have to type is:
"git send-email --to linux-ext4 /tmp/p")

2) While lsb_release is mandatory on Ubuntu systems (there is a
dependency from ubuntu-minimal), it is not guaranteed to exist on
Debian systems.  So how I already test for Ubuntu in the rules file is
via this construct:

	if test -f /etc/lsb-release && \
		grep -q DISTRIB_ID=Ubuntu /etc/lsb-release; then \
	$(INSTALL) -p -m 0644 e2fsck/e2fsck.conf.ubuntu \
       		${debdir}/e2fsprogs/etc/e2fsck.conf; \
	fi

Hmm, one of these days I should probably check and see if Ubuntu
finally fixed the installer and init scripts breakage which forced me
to set a special e2fsck.conf file just for Ubuntu.  (See git commit
60702c26 in the e2fsprogs repository for more details.)

But in any case, I'd suggest checking for Ubuntu using the above
construct instead of trying to use the lsb_release command, since it's
not guaranteed to be there on Debian systems.

3) In the "nice to have" category, it would be nice if whether or not
blkid is built is controled via DEB_BUILD_OPTIONS flag instead of a
free-standard environment variable, but I won't insist on that.

					- Ted
