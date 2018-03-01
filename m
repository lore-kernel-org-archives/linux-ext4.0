From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: EXT4 Oops (Re: [PATCH V15 06/22] mmc: block: Add blk-mq support)
Date: Thu, 1 Mar 2018 13:20:16 -0700
Message-ID: <AF3403B9-9791-4A77-A6FB-3281B8EA7A31@dilger.ca>
References: <1511962879-24262-1-git-send-email-adrian.hunter@intel.com>
 <1511962879-24262-7-git-send-email-adrian.hunter@intel.com>
 <bc65b542-9703-aa04-f1c7-b10584e44391@gmail.com>
 <829308a3-3bf6-c173-65fa-e2a0f45f7f61@intel.com>
 <68886f99-97f5-897a-f754-6f414741bd5a@gmail.com>
 <22580b82-0257-b156-9f0c-79afa34067e5@gmail.com>
 <8876217f-ede6-fc81-2e05-b4fc976b3235@intel.com>
 <6a1267b0-6242-fc9f-60ed-02bf34677b62@intel.com>
 <20180301160418.GA2490@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_83C1D3F3-F6FF-4590-B7E4-E000F852A5BA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bough Chen <haibo.chen@nxp.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        Mateusz Nowak <mateusz.nowak@intel.com>,
        Yuliy Izrailov <Yuliy.Izrailov@sandisk.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Dong Aisheng <dongas86@gmail.com>,
        Das Asutosh <asutoshd@codeaurora.org>,
        Zhangfei Gao <zhangfei.gao@gmail.com>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Harjani Ritesh <riteshh@codeaurora.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Lin <shawn.lin@rock-chi
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180301160418.GA2490@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_83C1D3F3-F6FF-4590-B7E4-E000F852A5BA
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


On Mar 1, 2018, at 9:04 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> This doesn't seem to make sense; the PC is where we are currently
> executing, and LR is the "Link Register" where the flow of control
> will be returning after the current function returns, right?  Well,
> dx_probe should *not* be returning to __wait_on_bit().  So this just
> seems.... weird.
> 
> Ignoring the LR register, this stack trace looks sane...  I can't see
> which pointer could be NULL and getting dereferenced, though.  How
> easily can you reproduce the problem?  Can you either (a) translate
> the PC into a line number, or better yet, if you can reproduce, add a
> series of BUG_ON's so we can see what's going on?
> 
> +	BUG_ON(frame);

I think you mean:
	BUG_ON(frame == NULL);
or
	BUG_ON(!frame);


> 	memset(frame_in, 0, EXT4_HTREE_LEVEL * sizeof(frame_in[0]));
> 	frame->bh = ext4_read_dirblock(dir, 0, INDEX);
> 	if (IS_ERR(frame->bh))
> 		return (struct dx_frame *) frame->bh;
> 
> +	BUG_ON(frame->bh);
> +	BUG_ON(frame->bh->b_data);

Same here.

	BUG_ON(frame->bh == NULL);
	BUG_ON(frame->bh->b_data == NULL);

This is why I don't like implicit "is NULL" or "is non-zero" usage.  Lustre
used to require "== NULL" or "!= NULL" to avoid bugs like this, but had to
abandon that because of upstream code style.

> 	root = (struct dx_root *) frame->bh->b_data;
> 	if (root->info.hash_version != DX_HASH_TEA &&
> 	    root->info.hash_version != DX_HASH_HALF_MD4 &&
> 	    root->info.hash_version != DX_HASH_LEGACY) {
> 
> These are "could never" happen scenarios from looking at the code, but
> that will help explain what is going on.
> 
> If this is reliably only happening with mq, the only way I could see
> that if is something is returning an error when it previously wasn't.
> This isn't a problem we're seeing with any of our testing, though.
> 
> Cheers,
> 
> 						- Ted
> 


Cheers, Andreas






--Apple-Mail=_83C1D3F3-F6FF-4590-B7E4-E000F852A5BA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlqYYIAACgkQcqXauRfM
H+D1MQ/9HoJWn769M05/z1EIBrSufibX73AF41nPOwDkOkmUvcmf+48coM0H1y2y
HJl6JonNCNZ/wPvpo8yFrXjrZ8/1R0Cekk0nptM9Zokg3ufJygmU8+BB3smeHB7L
nw1O4ftW1jAXFGGDdj/HiB4Fuy5vij6FgpFaRLz5VtoenkL509d8WBZoRHBnBHsz
RWD05dB/Hx6s9jVnVs6BkH9Q9r7qxLIjIq24hp6qKy1Zvu1GwjTxMEfqNADEj0Sf
TjJ/AfG1kCtxnvhYsk2JRhnEj1b7xNbb+eFd9+T4ca/oB4o5hn3BltNBbDMReQBZ
UHAzhf8N5w+k8psDLXpOl9HjQue9H+bPlYbF4g3JUHWhbRklWiObTU5XULegTNRc
vVmsmw4iYIve6FEp3neb/DfLrKOnLHWBakESxVZel6N42OxFGJYk0XQc2XmoNCyj
uC/HgZWV2Iah5F3o0HLpnWHnr2xWE/AVrIhCK2p5ecLq16niFCMh1CCksGqrrqwx
eIirkF1z9atKTe4XTf7412gPSood0PjbT/2qe5FDLpRtdTiwDA8SMc+pDw7UpbYj
ymhDIbQf019VSXV9AzN3rktNPaaya+HNSuxqkG26R2jLRsbf3qml1snoUjKga1fS
DDu5H/nwTLVsjypDHpDapoXul04KRphOKdfUi5z+xJSXLUTwySI=
=Vg/6
-----END PGP SIGNATURE-----

--Apple-Mail=_83C1D3F3-F6FF-4590-B7E4-E000F852A5BA--
