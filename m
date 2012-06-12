From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Tue, 12 Jun 2012 14:19:58 -0400
Message-ID: <20120612181958.GB1803@thunk.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
 <201206121329.25953.arnd.bergmann@linaro.org>
 <CAKLKtzdLvRNFWiAV_ssFfSQFTMmgq+jHq4LNG9H70Zq9WZm5yg@mail.gmail.com>
 <201206121455.50639.arnd.bergmann@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201206121455.50639.arnd.bergmann@linaro.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 12, 2012 at 02:55:50PM +0000, Arnd Bergmann wrote:
> 
> As I said, it's not a technical limitation, but a logical conclusion
> from trying to use the context ID for something useful. The only
> reason to use context ID in the first place is to reduce the amount
> of garbage collection in the device (improving performance and expected
> life of the device), so any context ID annotations we make should be
> directed at giving useful information to the device to actually do that.

... and a big part of that is knowing what is the downside if we give
incorrect information to the device.  And what are the exact
implications of what it means to group a set of blocks into a
"context".

If it is fundamentally a promise that blocks in a context will be
overwritten or trimmed at the same time then is it counterproductive
to group blocks for overwrite-in-place database where the lifetimes of
the block are extremely different?  Is that giving "wrong" information
going to significantly increase the write amplification factor? 

It may be that the standard doesn't actually answer these questions
and even worse, SSD manufactures may be stupidly trying to keep this
stuff as a "trade securet" --- but we do need to know in order to
optimize performance on real hardware....

					- Ted
