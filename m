From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Tue, 12 Jun 2012 14:55:50 +0000
Message-ID: <201206121455.50639.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206121329.25953.arnd.bergmann@linaro.org> <CAKLKtzdLvRNFWiAV_ssFfSQFTMmgq+jHq4LNG9H70Zq9WZm5yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org
To: Saugata Das <saugata.das@linaro.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <CAKLKtzdLvRNFWiAV_ssFfSQFTMmgq+jHq4LNG9H70Zq9WZm5yg@mail.gmail.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 12 June 2012, Saugata Das wrote:
> > I don't think that is correct. The most obvious implementation in eMMC
> > hardware for this would be to group all data from one context to be
> > written into the same erase block, in order to reduce the amount
> > of garbage collection that needs to happen at erase time. AFAICT,
> > the main interest here is, as Ted is guessing correctly, to make sure
> > that all data which gets written into one context has roughly the
> > same life time before it gets erased or overwritten.
> 
> The restriction is there on "large unit" context, which prevents
> trim/erase of the blocks till the context is active. But we do not
> enable "large unit". On non-"large unit" context, the specification
> does not restrict the trim/erase of blocks based on context.

As I said, it's not a technical limitation, but a logical conclusion
from trying to use the context ID for something useful. The only
reason to use context ID in the first place is to reduce the amount
of garbage collection in the device (improving performance and expected
life of the device), so any context ID annotations we make should be
directed at giving useful information to the device to actually do that.

	Arnd
