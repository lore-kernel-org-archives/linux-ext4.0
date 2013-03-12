From: Sander <sander@humilis.net>
Subject: Re: torrent hash failures since 3.9.0-rc1
Date: Tue, 12 Mar 2013 09:28:54 +0100
Message-ID: <20130312082854.GA1515@panda>
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130311204625.GA433@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Markus Trippelsdorf wrote (ao):
> On 2013.03.11 at 16:37 -0400, Theodore Ts'o wrote:
> > We actually run fsx in a number of different configruations as part of
> > our regression testing before we send Linus a pull request, and
> > haven't found any issues.  So unless it's a hardware problem, it seems
> > unlikely to me that your running fsx would turn up anything.
> 
> Yes, I let it run for a while anyway and it didn't report any failure.

> Please note that my local rtorrent version was configured with
> "--with-posix-fallocate".

Would it be possible to enhance fsx to detect such an issue?

	Sander
