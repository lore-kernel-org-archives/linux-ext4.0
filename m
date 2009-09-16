From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/4]ext4: Fix different block exchange issue in
	EXT4_IOC_MOVE_EXT
Date: Wed, 16 Sep 2009 14:20:57 -0400
Message-ID: <20090916182057.GF15451@mit.edu>
References: <4AADFC1A.7020609@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Peng Tao <bergwolf@gmail.com>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37830 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZIPSU4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Sep 2009 14:20:56 -0400
Content-Disposition: inline
In-Reply-To: <4AADFC1A.7020609@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 14, 2009 at 05:17:30PM +0900, Akira Fujita wrote:
> ext4: Fix different block exchange issue in EXT4_IOC_MOVE_EXT
>=20
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>=20
> If logical block offset of original file which is passed to
> EXT4_IOC_MOVE_EXT is different from donor file's,
> a calculation error occurs in ext4_calc_swap_extents(),
> therefore wrong block is exchanged between original file and donor fi=
le.
> As a result, we hit ext4_error() in check_block_validity().
> To detect the logical offset difference in EXT4_IOC_MOVE_EXT,
> add checks to mext_calc_swap_extents() and handle it as error,
> since data exchange must be done between the same blocks in EXT4_IOC_=
MOVE_EXT.
>=20
> Reported-by: Peng Tao=E3=80=80<bergwolf@gmail.com>=E3=80=80
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Applied, thanks.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
