From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Tue, 13 May 2008 05:23:11 +0100
Message-ID: <20080513042311.GA22226@linux-mips.org>
References: <20080512130604.GA15008@deprecation.cyrius.com> <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com> <20080512143426.GB7029@mit.edu> <20080512145836.GE15866@deprecation.cyrius.com> <90edad820805120814l7ee3f5d3h7f9939854bccf0@mail.gmail.com> <20080512173537.GG7029@mit.edu> <90edad820805121237r7f4b6e16g135df49cfe27499a@mail.gmail.com> <20080513105549.bb1563f8.sfr@canb.auug.org.au> <20080513114244.736cf625.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Martin Michlmayr <tbm@cyrius.com>, linux-mips@linux-mips.org,
	linux-ext4@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <20080513114244.736cf625.sfr@canb.auug.org.au>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 13, 2008 at 11:42:44AM +1000, Stephen Rothwell wrote:

> Also, the only compiler version that crosstool seems to know about for
> mips is 3.4.5.  Is this version ok for building mips kernels?

Minimum is 3.2 for building a 32-bit kernel and 3.3 for a 64-bit kernel
but I really wouldn't recommend anything older than 3.4.

There are crosscompiler rpms on ftp.linux-mips.org in
/pub/linux/mips/crossdev for various host / target combinations.  They
come without libraries so just good enough for building kernels - but that's
the only purpose I build them for.  Also I don't have access to a powerpc
box so no power rpms.

  Ralf
