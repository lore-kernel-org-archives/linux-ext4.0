From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4: deadlock occurs when running fsstress and ENOSPC errors
 are seen.
Date: Wed, 16 Apr 2014 01:07:29 -0400
Message-ID: <20140416050729.GD21807@thunk.org>
References: <CADDb1s2RvN_S+abFXCe4ZhZPKZgP_PiocJdpiLzRC_Se5sgVVg@mail.gmail.com>
 <20140415124743.GD3403@thunk.org>
 <CADDb1s3HYDvb51Ngrwk82gkpbUWg1bRo7kaUmbGRmb0g_9JKgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, darrick.wong@oracle.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADDb1s3HYDvb51Ngrwk82gkpbUWg1bRo7kaUmbGRmb0g_9JKgw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 16, 2014 at 10:30:10AM +0530, Amit Sahrawat wrote:
> 4)	Corrupt the block group =E2=80=981=E2=80=99  by writing all =E2=80=
=981=E2=80=99, we had one file
> with all 1=E2=80=99s, so using =E2=80=98dd=E2=80=99 =E2=80=93
> dd if=3Di_file of=3D/dev/sdb1 bs=3D4096 seek=3D17 count=3D1
> After this mount the partition =E2=80=93 create few random size files=
 and then
> ran =E2=80=98fsstress,

Um, sigh.  You didn't say that you were deliberately corrupting the
file system.  That wasn't in the subject line, or anywhere else in the
original message.

So the question isn't how the file system got corrupted, but that
you'd prefer that the system recovers without hanging after this
corruption.

I wish you had *said* that.  It would have saved me a lot of time,
since I was trying to figure out how the system had gotten so
corrupted (not realizing you had deliberately corrupted the file
system).

So I think if you run "tune2fs -e remount-ro /dev/sdb1" before you
started the fsstress, the file system would have remounted the
filesystem read-only at the first EXT4-fs error message.  This would
avoid the hang that you saw, since the file system would hopefully
"failed fast", before th euser had the opportunity to put data into
the page cache that would be lost when the system discovered there was
no place to put the data.

Regards,

						- Ted
