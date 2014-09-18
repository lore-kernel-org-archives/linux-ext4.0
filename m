From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Call trace in ext4_es_lru_add on 3.10 stable
Date: Thu, 18 Sep 2014 15:43:11 -0400
Message-ID: <20140918194311.GE19520@thunk.org>
References: <541AD93A.70203@profihost.ag>
 <20140918192131.GD19520@thunk.org>
 <541B32A1.3080706@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"p.herz@profihost.ag >> Philipp Herz - Profihost AG"
	<p.herz@profihost.ag>, stable@vger.kernel.org
To: Stefan Priebe <s.priebe@profihost.ag>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <541B32A1.3080706@profihost.ag>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 18, 2014 at 09:29:37PM +0200, Stefan Priebe wrote:
> 
> Sorry but whole output is:
> 2014-09-18 02:30:34     0000000000000000 ffff881021663b20 ffff881021663b08
> ffffffffa02d66b3
		...

That's not the whole message; you just weren't able to capture it all.
How are you capturing these messages, by the way?  Serial console?   

It this reproducible?   Can you try a newer kernel?

Cheers,

					- Ted
