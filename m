From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Filesystem benchmarks on reasonably fast hardware
Date: Wed, 27 Jul 2011 11:39:08 +0800
Message-ID: <CAGBYx2aSK2p9_X45p5AM=BPFOzwWDHUDxtf3Q7xrvT1dHKrquw@mail.gmail.com>
References: <20110717160501.GA1437@logfs.org>
	<20110718120751.GH14869@thunk.org>
	<20110718124229.GG1437@logfs.org>
	<20110725151825.GI3469@thunk.org>
	<20110725182037.GE26160@logfs.org>
	<20110726145736.GA7684@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
	"Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110726145736.GA7684@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi  J=F6rn and Ted,

Could you anyone send out the ext4 lock stat on the list?

Thank you,
Yongqiang.


On Tue, Jul 26, 2011 at 10:57 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Jul 25, 2011 at 08:20:37PM +0200, J=F6rn Engel wrote:
>> On Mon, 25 July 2011 11:18:25 -0400, Ted Ts'o wrote:
>> >
>> > Did you have a chance to do an ext4 lockstat run?
>
> Hi J=F6rn,
>
> Thanks for forwarding it to me. =A0It's the same problem as in XFS, t=
he
> excessive coverage of the i_mutex lock. =A0In ext4's case, it's in th=
e
> generic generic_file_aio_write() machinery where we need to do the
> lock busting. =A0(XFS apparently doesn't use the generic routines, so
> the fix that Dave did won't help ext3 and ext4.)
>
> I don't have the time to look at it now, but I'll put it on my todo
> list; or maybe someone with a bit more time can look into how we migh=
t
> be able to use a similar approach in the generic file system code.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
