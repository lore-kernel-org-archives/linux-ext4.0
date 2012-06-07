From: Kees Cook <keescook@chromium.org>
Subject: Re: [dm-devel] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741:
 group 1904, 32254 clusters in bitmap, 32258 in gd
Date: Thu, 7 Jun 2012 15:40:40 -0700
Message-ID: <CAGXu5jKmBkfvuSR7q47-Ac57dVZynz_JkYXiA_-aXaGQiR_C4g@mail.gmail.com>
References: <471046920.20120604234941@eikelenboom.it>
	<20120605000356.GM29466@outflux.net>
	<1018371644.20120605224154@eikelenboom.it>
	<20120605210806.GB7182@thunk.org>
	<1883708187.20120606090126@eikelenboom.it>
	<CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com>
	<1482118647.20120606164012@eikelenboom.it>
	<20120607042756.GA30776@thunk.org>
	<20120607222729.GI6938@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Sander Eikelenboom <linux@eikelenboom.it>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120607222729.GI6938@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 7, 2012 at 3:27 PM, djwong <djwong@us.ibm.com> wrote:
> On Thu, Jun 07, 2012 at 12:27:56AM -0400, Ted Ts'o wrote:
>> I think this patch should fix things. =A0Could you give it a try (af=
ter
>> re-enabling uninit_bg and then running e2fsck on the file systems)?
>>
>> Many thanks,
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 - Ted
>>
>> commit b6b218940d47f20fc14e4d203930c575be0c65bf
>> Author: Theodore Ts'o <tytso@mit.edu>
>> Date: =A0 Thu Jun 7 00:26:56 2012 -0400
>>
>> =A0 =A0 ext4: fix the free blocks calculation for ext3 file systems =
w/ uninit_bg
>>
>> =A0 =A0 Ext3 filesystems that are converted to use as many ext4 file=
 systems
>> =A0 =A0 as possible
>
> Just to clarify the description a bit:
>
> Did you mean "..as many ext4 filesystem _features_ as possible" ?
>
>> will enable uninit_bg to speed up e2fsck times. =A0File
>> =A0 =A0 systems with an native ext3 layout of inode tables and block
>
> Perhaps "On file systems with a native ext3 layout..." ?

=46WIW, I was building the filesystem that triggered this as ext4:

  mkfs.ext4 -T default -m 0 -O ^huge_file,^flex_bg -E
discard,lazy_itable_init /dev/mapper/...

-Kees

--=20
Kees Cook
Chrome OS Security
