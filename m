From: Vitez Gabor <vitezg@niif.hu>
Subject: Re: support freeze operation like xfs_freeze
Date: Mon, 29 Jan 2007 10:57:44 +0100
Message-ID: <20070129095744.GB32517@swszl.szkp.uni-miskolc.hu>
References: <20070125172818.GA25037@swszl.szkp.uni-miskolc.hu> <45B907CA.70309@redhat.com> <20070126212208.GA9897@thunk.org> <45BA7F5A.5000703@redhat.com> <20070127011013.GB9897@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from swszl.szkp.uni-miskolc.hu ([193.6.2.24]:33735 "EHLO
	swszl.szkp.uni-miskolc.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbXA2J5q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jan 2007 04:57:46 -0500
Content-Disposition: inline
In-Reply-To: <20070127011013.GB9897@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 26, 2007 at 08:10:13PM -0500, Theodore Tso wrote:
> The question really is what are the legimate uses of such a facility
> where you wouldn't be better off taking a snapshot and then doing the
> backup dump on the snapshot?  The real issue is that we can't take
> snapshots on plain block devices, but that might be the better problem
> to solve....

I personnaly use xfs_freeze to get a bit of extra protection from filesystem
corruption would suspend-to-disk or suspend to ram go wrong. Read-only
remount is not an option because X is running, etc..


   Gabor
