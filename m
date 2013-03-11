From: Dave Jones <davej@redhat.com>
Subject: Re: torrent hash failures since 3.9.0-rc1
Date: Mon, 11 Mar 2013 19:26:15 -0400
Message-ID: <20130311232615.GA28659@redhat.com>
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
 <20130311211833.GC15478@thunk.org>
 <20130311213837.GA438@x4>
 <20130311231227.GA319@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130311231227.GA319@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 12, 2013 at 12:12:27AM +0100, Markus Trippelsdorf wrote:
 > > I've started a full bisection from v3.8 to todays git tree. It will take
 > > ~13 steps. However it's already late here in Germany. I will continue
 > > the bisection tomorrow and report back.
 > 
 > The issue started with:
 > 
 > 74cd15cd02708c7188581f279f33a98b2ae8d322 is the first bad commit
 > commit 74cd15cd02708c7188581f279f33a98b2ae8d322
 > Author: Zheng Liu <wenqing.lz@taobao.com>
 > Date:   Mon Feb 18 00:32:55 2013 -0500
 > 
 >     ext4: reclaim extents from extent status tree
 > 
 > Please note that my local rtorrent version was configured with
 > "--with-posix-fallocate". I'm not sure if distributions also enable this
 > flag, but it could explain why Ted and Dave weren't able to reproduce
 > the problem so far.

Looks like Fedora doesn't, so indeed that could explain it.

	Dave
