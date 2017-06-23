From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Return EIO on read error in ext4_find_entry
Date: Fri, 23 Jun 2017 00:33:02 -0600
Message-ID: <204110E6-EECE-4925-9020-EC6D9633C822@dilger.ca>
References: <20170622232307.48392-1-khazhy@google.com> <20170623044314.7f23ighkelnpgnah@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Khazhismel Kumykov <khazhy@google.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170623044314.7f23ighkelnpgnah@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 22, 2017, at 22:43, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
>> On Thu, Jun 22, 2017 at 04:23:07PM -0700, Khazhismel Kumykov wrote:
>> Previously, a read error would be ignored and we would eventually return
>> NULL from ext4_find_entry, which signals "no such file or directory". We
>> should be returning EIO.
>>=20
>> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
>=20
> Thanks, applied.

I don't necessarily agree that this is an improvement.=20

If the requested entry is not in the bad block, this will return an error ev=
en if the file name could be found in another block. It would be better to s=
ave the error until the end and only return -EIO if the entry cannot be foun=
d.=20

Cheers, Andreas=
