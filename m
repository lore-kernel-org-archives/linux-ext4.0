From: Rob Landley <rob@landley.net>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3: document conditions when reliable operation is possible)
Date: Wed, 2 Sep 2009 17:45:34 -0500
Message-ID: <200909021745.36687.rob@landley.net>
References: <20090826001645.GN4300@elf.ucw.cz> <4A9910D5.4060208@redhat.com> <20090902201210.GC1840@ucw.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090902201210.GC1840@ucw.cz>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday 02 September 2009 15:12:10 Pavel Machek wrote:
> > (2) RAID5 protects you against a single failure and your test case
> > purposely injects a double failure.
>
> Most people would be surprised that press of reset button is 'failure'
> in this context.

Apparently because most people haven't read Documentation/md.txt:

  Boot time assembly of degraded/dirty arrays
  -------------------------------------------

  If a raid5 or raid6 array is both dirty and degraded, it could have
  undetectable data corruption.  This is because the fact that it is
  'dirty' means that the parity cannot be trusted, and the fact that it
  is degraded means that some datablocks are missing and cannot reliably
  be reconstructed (due to no parity).

And so on for several more paragraphs.  Perhaps the documentation needs to be 
extended to note that "journaling will not help here, because the lost data 
blocks render entire stripes unreconstructable"...

Hmmm, I'll take a stab at it.  (I'm not addressing the raid 0 issues brought 
up elsewhere in this thread because I don't comfortably understand the current 
state of play...)

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
