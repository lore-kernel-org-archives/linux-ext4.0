From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
Date: Wed, 3 Apr 2013 08:20:58 -0400
Message-ID: <20130403122058.GB7741@thunk.org>
References: <87fvzaspr8.fsf@openvz.org>
 <874841142.414482.1364875584266.JavaMail.root@redhat.com>
 <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org>
 <877gkls1q7.fsf@openvz.org>
 <alpine.DEB.2.10.1304021430480.13746@trent.utfs.org>
 <87r4isd1vn.fsf@openvz.org>
 <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org>
 <87li90q9mx.fsf@openvz.org>
 <87hajoq6s2.fsf@openvz.org>
 <20130403102204.GA15383@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dmitry Monakhov <dmonakhov@openvz.org>,
	Christian Kujau <lists@nerdbynature.de>,
	CAI Qian <caiqian@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130403102204.GA15383@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 03, 2013 at 06:22:04PM +0800, Zheng Liu wrote:
> Subject: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When an extent was zeroed out, we forgot to do convert from cpu to le16.
> It could make us hit a BUG_ON when we try to write dirty pages out.  So
> fix it.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks for finding this!  I think we should push this to Linus right
away, and not wait for the next merge window.  The bug has been here
for a long time, but it was unmasked by the fact that we unbroke
extent zeroing in 3.9-rcX.

I have two big questions.  (1) Shouldn't Eric Whitney have picked this
up with his ARM pandaboard testing, since IIRC it's big-endian as
well?  If not, is there something we can do to improve our testing wrt
to big-endian systems?

And (2) does it make sense to have an inline function
ext4_ext_set_len(len)?  It might save some lines of code, but more
importantly, it might make it less likely that we will overlook this
sort of bug in the future.

					- Ted
