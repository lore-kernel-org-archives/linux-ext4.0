From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 quota tests?
Date: Tue, 26 Jan 2010 19:35:00 +0100
Message-ID: <20100126183500.GJ3187@quack.suse.cz>
References: <6601abe91001260931i39328e77kfe984834275c1282@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab0AZSey (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jan 2010 13:34:54 -0500
Content-Disposition: inline
In-Reply-To: <6601abe91001260931i39328e77kfe984834275c1282@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Curt,

On Tue 26-01-10 09:31:24, Curt Wohlgemuth wrote:
> I heard from the ext4 conference call yesterday that you might have
> some quota tests that would be useful.  Can you give me a pointer to
> where I might find them?
  Hum, I have some scripts I use for testing of quota but it's nothing
too clever. What exactly would you like to test? What generally needs to be
tested from filesystem POV (since I guess that's what you're interested in)
is whether quota accounting matches the real usage. So what I do is:

run the load I want to check
quotaoff -vu $mntpoint
repquota -u $mntpoint | sed -ne '6,$p' | tr -s ' ' | sort >before_check
quotacheck -vu $mntpoint
repquota -u $mntpoint | sed -ne '6,$p' | tr -s ' ' | sort >after_check
diff before_check after_check >/dev/null || echo "Quota usage differs!"

For "load I want to check" I usually use fsstress, fsx-linux or similar
programs.

Oh, and when I want to be nasty, I also test load like:
as root do:
  while true; do
    BLOCKLIMIT=$minblimit+$((RANDOM%($maxblimit-$minblimit)))
    INODELIMIT=$minilimit+$((RANDOM%($maxilimit-$minilimit)))
    setquota -u testuser 0 $BLOCKLIMIT 0 $INODELIMIT $mntpoint
    sleep 1
  done

as testuser do:
  while true; do tar xzf some_larger_archive.tar.gz; rm -rf archive; done

Possibly you might also want to run 'sync' in parallel once in a while to
make the mix more interesting. The point is to test whether allocation
failure paths work right...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
