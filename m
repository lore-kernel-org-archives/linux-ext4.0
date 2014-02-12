From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/21] fs: Mark functions as static in jbd2/journal.c
Date: Wed, 12 Feb 2014 12:36:07 -0500
Message-ID: <20140212173607.GH14520@thunk.org>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
 <b13f571ff87a2ee1942578a97b00823373e9bd79.1391949868.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	josh@joshtriplett.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b13f571ff87a2ee1942578a97b00823373e9bd79.1391949868.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Feb 09, 2014 at 06:41:21PM +0530, Rashika Kheria wrote:
> Mark functions as static in jbd2/journal.c because they are not used
> outside this file.
>=20
> This eliminates the following warning in jbd2/journal.c:
> fs/jbd2/journal.c:125:5: warning: no previous prototype for =E2=80=98=
jbd2_verify_csum_type=E2=80=99 [-Wmissing-prototypes]
> fs/jbd2/journal.c:146:5: warning: no previous prototype for =E2=80=98=
jbd2_superblock_csum_verify=E2=80=99 [-Wmissing-prototypes]
> fs/jbd2/journal.c:154:6: warning: no previous prototype for =E2=80=98=
jbd2_superblock_csum_set=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thanks, applied to the ext4 tree.

					- Ted
