From: James Cloos <cloos@jhcloos.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
Date: Sat, 20 Feb 2010 10:59:31 -0500
Message-ID: <m3fx4vnbic.fsf@lugabout.jhcloos.org>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	<20100215154516.GB11057@think> <m3d403632g.fsf@lugabout.jhcloos.org>
	<21d7e9971002191302s76111f6fyd986c51b66e214ae@mail.gmail.com>
	<m3wry8nbyl.fsf@lugabout.jhcloos.org>
	<21d7e9971002191403tdc16bf9h5ebf6b48fec95d6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
To: Dave Airlie <airlied@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <21d7e9971002191403tdc16bf9h5ebf6b48fec95d6a@mail.gmail.com>
	(Dave Airlie's message of "Sat, 20 Feb 2010 08:03:57 +1000")
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Dave" =3D=3D Dave Airlie <airlied@gmail.com> writes:

>>=20
>> OK. =A0I do use radeon kms (r100).

Dave> I've just sent a pull req to Linus
Dave> http://bugzilla.kernel.org/show_bug.cgi?id=3D15328
Dave> this

Dave> http://bugzilla.kernel.org/attachment.cgi?id=3D25107
Dave> patch.

I'll give that a try as soon as I can schedule a reboot.

Dave> The relevant piece of dmesg is at the top ;-), where
Dave> it states if you have PAT support or not, but I
Dave> suspect if you try this patch it'll fix it.

Oh.  I thought you were referring to errors....

Anyway, no, the p3m does not support PAT:

[    0.000000] PAT not supported by CPU.

-JimC
--=20
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
