From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Tue, 12 Jun 2012 16:41:28 -0400
Message-ID: <20120612204128.GF12161@thunk.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
 <201206121455.50639.arnd.bergmann@linaro.org>
 <20120612181958.GB1803@thunk.org>
 <201206122007.28514.arnd.bergmann@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201206122007.28514.arnd.bergmann@linaro.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 12, 2012 at 08:07:28PM +0000, Arnd Bergmann wrote:
> Right. The danger here is that the context support was described in
> the standard first, while none of the devices seem to even be
> smart enough to make use of the information we put in there. Once
> operating systems start putting some data in there, at least
> some manufacturers will start making use of that data to optimize
> the accesses, but it's very unlikely that they will tell us exactly
> what they are doing. Having code in ext4 that uses the contexts will
> at least make it more likely that the firmware optimizations are
> based on ext4 measurements rather than some other file system or
> operating system.
>
> From talking with the emmc device vendors, I can tell you that ext4
> is very high on the list of file systems to optimize for, because
> they all target Android products.

Well, I have a contact at SanDisk where I can discuss things under
NDA, if that will help.  He had reached out to me specifically because
of ext4 and Android --- he's the guy that I invited to give a talk at
the LSF workshop last year.

					- Ted
