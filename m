From: Dave Airlie <airlied@gmail.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
Date: Sat, 20 Feb 2010 08:03:57 +1000
Message-ID: <21d7e9971002191403tdc16bf9h5ebf6b48fec95d6a@mail.gmail.com>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	 <20100215154516.GB11057@think> <m3d403632g.fsf@lugabout.jhcloos.org>
	 <21d7e9971002191302s76111f6fyd986c51b66e214ae@mail.gmail.com>
	 <m3wry8nbyl.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
To: James Cloos <cloos@jhcloos.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <m3wry8nbyl.fsf@lugabout.jhcloos.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>
> OK. =A0I do use radeon kms (r100).

I've just sent a pull req to Linus
http://bugzilla.kernel.org/show_bug.cgi?id=3D15328
this

http://bugzilla.kernel.org/attachment.cgi?id=3D25107
patch.

The relevant piece of dmesg is at the top ;-), where
it states if you have PAT support or not, but I
suspect if you try this patch it'll fix it.

Dave.
