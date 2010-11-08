From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v4] ext4: handle writeback of inodes which are being
 freed
Date: Mon, 8 Nov 2010 11:54:20 -0500
Message-ID: <20101108165420.GE3099@thunk.org>
References: <20101102202013.GA3861@elliptictech.com>
 <20101103181412.GH25614@thunk.org>
 <20101103182229.GA8766@elliptictech.com>
 <20101103205306.GA3627@elliptictech.com>
 <20101107212143.GA28396@thunk.org>
 <20101108011919.GN13830@dastard>
 <20101108050052.GA3099@thunk.org>
 <20101108060535.GB3099@thunk.org>
 <20101108162832.GA22401@elliptictech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101108162832.GA22401@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 08, 2010 at 11:28:32AM -0500, Nick Bowler wrote:
> 
> After several successful 'make install' tests with this patch:
> 
> Tested-by: Nick Bowler <nbowler@elliptictech.com>
> 
> Thanks.

Thank you for reporting the bug and testing the patches!!

      	      		    	- Ted
