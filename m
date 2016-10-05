From: Jan Kara <jack@suse.cz>
Subject: Re: Frequent ext4 oopses with 4.4.0 on Intel NUC6i3SYB
Date: Wed, 5 Oct 2016 08:20:53 +0200
Message-ID: <20161005062053.GD20752@quack2.suse.cz>
References: <fcb653b9-cd9e-5cec-1036-4b4c9e1d3e7b@gmx.de>
 <20161004084136.GD17515@quack2.suse.cz>
 <90dfe18f-9fe7-819d-c410-cdd160644ab7@gmx.de>
 <2b7d6bd6-7d16-3c60-1b84-a172ba378402@gmx.de>
 <CABYiri-UUT6zVGyNENp-aBJDj6Oikodc5ZA27Gzq5-bVDqjZ4g@mail.gmail.com>
 <087b53e5-b23b-d3c2-6b8e-980bdcbf75c1@gmx.de>
 <CABYiri_3qS6XgT04hCeF1AMuxY6W0k7QVEO-N0ZodeJTdG=xsw@mail.gmail.com>
 <26892620-eac1-eed4-da46-da9f183d52b1@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrey Korolyov <andrey@xdel.ru>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
To: Johannes Bauer <dfnsonfsduifb@gmx.de>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <26892620-eac1-eed4-da46-da9f183d52b1@gmx.de>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue 04-10-16 23:54:24, Johannes Bauer wrote:
> > - disk accesses and corresponding power spikes are causing partial
> > undervoltage condition somewhere where bits are relatively freely
> > flipping on paths without parity checking, though this could be
> > addressed only to an onboard power distributor, not to power source
> > itself.
> 
> Huh that sounds like "defective hardware" to me, wouldn't it?

Yeah, from the frequency and the kind of failures, I actually don't think
it's a kernel bug anymore. So I'd also suspect something like that bits on
memory bus start to flip when the disk is loaded or something like that.

If you say compilation on tmpfs is fine - can you try compiling kernel in
tmpfs in a loop and then after it is running smoothly for a while start to
load the disk by copying a lot of data there? Do the errors trigger?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
