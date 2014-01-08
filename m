From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: xfstests failures in v3.13-rc7
Date: Wed, 8 Jan 2014 03:33:29 -0700
Message-ID: <20140108103329.GA29910@parisc-linux.org>
References: <1389063428.2169.12.camel@ancientdefender.lm.intel.com> <CAGW2f1Hdv42u=yHoFVhmx72z88gyNUC4MbQQ0UGk8BceNNEbGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51907 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbaAHKdb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jan 2014 05:33:31 -0500
Content-Disposition: inline
In-Reply-To: <CAGW2f1Hdv42u=yHoFVhmx72z88gyNUC4MbQQ0UGk8BceNNEbGA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 08, 2014 at 04:56:19AM +0000, jon ernst wrote:
> I am ext4 newbie. Though I could share my experience about test 013 failure.
> Make sure you have latest (or 1.42.9) e2fsck installed on your system.
> 
> Notice that v1.42.8 will cause 013 fail due to this:
> http://comments.gmane.org/gmane.comp.file-systems.ext4/39980

Thank you, Jon!  I installed 1.42.9 and 013 ran successfully.  Now that
lazy Debian maintainer needs to package it!

(Seriously, 1.42.9-2 is already in unstable; it just needs another 2
days to migrate to testing.  Good job, Ted :-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
