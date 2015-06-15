From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1 linux-next] ext4: use swap() in memswap()
Date: Mon, 15 Jun 2015 00:05:00 -0400
Message-ID: <20150615040500.GC15793@thunk.org>
References: <1434128334-10302-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434128334-10302-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 12, 2015 at 06:58:54PM +0200, Fabian Frederick wrote:
> Use kernel.h macro definition.
> 
> Thanks to Julia Lawall for Coccinelle scripting support.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Thanks, applied.

					- Ted
