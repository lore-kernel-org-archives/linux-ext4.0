From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Commit 7d7345322d60edb0fa49a64a89b31360f01d09cb
Date: Wed, 23 Oct 2013 14:11:50 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310231404560.1918@localhost.localdomain>
References: <20131023103855.GF1275@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: stable@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20131023103855.GF1275@quack.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 23 Oct 2013, Jan Kara wrote:

> Date: Wed, 23 Oct 2013 12:38:55 +0200
> From: Jan Kara <jack@suse.cz>
> To: stable@vger.kernel.org
> Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
> Subject: Commit 7d7345322d60edb0fa49a64a89b31360f01d09cb
> 
>   Hello,
> 
>   can you please consider commit 7d7345322d60edb0fa49a64a89b31360f01d09cb "ext4: fix warning in
> ext4_da_update_reserve_space()" for -stable kernels (3.10 & 3.11 would make
> sense). Although the problem mostly results only in a warning, it can cause
> fs corruption in the rare case of hitting ENOSPC at the wrong moment.

I am not sure about that. First of all we would have to consider
commit 1c8924eb106c1ac755d5d35ce9b3ff42e89e2511 as well since you
make a use of the function introduced in that commit.

Also it's quite big change to be pushed to stable. However I think
that the warning is actually mostly harmless since we have

27dd43854227bb0e6ab70129bd21b60d396db2e7 ext4: introduce reserved
space


so If I am not missing something, then chances that we'll end up with
no space to allocate metadata blocks from are very very low.

Thanks!
-Lukas

> 
> 								Honza
> 
> 
