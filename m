From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4/ialloc.c: functions should not be declared extern
Date: Tue, 11 Oct 2011 23:10:01 -0400
Message-ID: <20111012031001.GF11548@thunk.org>
References: <201109231519.45350.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201109231519.45350.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 23, 2011 at 03:19:45PM -0700, H Hartley Sweeten wrote:
> The function declaration in ext4.h is already marked extern. =A0The f=
unction
> definition should not have the tag.
>=20
> This quiets the sparse noise:
>=20
> warning: function 'ext4_init_inode_table' with external linkage has d=
efinition
>=20
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>

Thanks, applied.

					-	 Ted
