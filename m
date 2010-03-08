From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: discard + LVM
Date: Mon, 8 Mar 2010 11:54:45 -0500
Message-ID: <170fa0d21003080854l1c7e8a76w277b1d1ce51da2e@mail.gmail.com>
References: <4B922929.5020006@zappa.cx> <4B933BD6.80100@redhat.com>
	 <yq18wa4c9qn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Sundstrom <sunkan@zappa.cx>,
	linux-ext4@vger.kernel.org, dm-devel@redhat.com,
	linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq18wa4c9qn.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Mar 7, 2010 at 12:38 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Eric" =3D=3D Eric Sandeen <sandeen@redhat.com> writes:
>
> Eric> Andreas Sundstrom wrote:
>>> Hi..
>>>
>>> I have an OCZ agility SSD drive with FW 1.5 that supports the TRIM
>>> command.
>>>
>>> I can see that it works on a plain partition. =A0But it does not se=
em
>>> to work together with LVM.
>>>
>>> So I'm wondering if this is expected and whether it is something th=
at
>>> will be worked on to get fixed?
>
> Eric> It is expected, as lvm is not yet passing discard requests.
>
> I'm working on this. =A0Missed the 2.6.34 merge window so I'm aiming =
at
> 2.6.35.

Hey Martin,

We've been scoping the work associated with adding discard support to
DM (afaik MD would need comparable infrastructure, e.g.: spliting
discard requests).

There is a fair amount of complexity associated with this work.
Especially when you look to support discards for some of the more
advanced DM targets.  Discard support for the 'linear' target is the
relatively low hanging fruit.  The 'striped' target gets more
interesting (having to split the discard into multiple discards to
submit to the appropriate underlying devices in the striped volume).

One thought was we might have a block layer hook along the lines of
the q->merge_bvec_fn (similar but hopefully less
problematic/controversial).  Christoph removed a hook that was vaguely
like this, but posed allocation problems, with linux-2.6 commit:
c15227de132f

Please feel free to share your patches/design with dm-devel.  (I'll
also check with Alasdair to see about making the dm-devel filtering
less prone to eat mail)

Thanks!
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
