From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: jbd2: don't wake kjournald unnecessarily
Date: Tue, 22 Jan 2013 00:29:46 +0100
Message-ID: <CA+icZUUA95x57CgLLtV6Z05aNv3FoTRDcmt71BwbqQLscrzwrw@mail.gmail.com>
References: <CA+icZUWOvk5i+XY22xdZYuxu=Vy3fG2QxJStEgNFQVS4u55y-w@mail.gmail.com>
	<CA+icZUUzNYE9QAh_p7=ZNuvZbxRPCb9zd4k7+aW-hv34mQWz=A@mail.gmail.com>
	<20130121104733.GE5588@quack.suse.cz>
	<CA+icZUVy-=jJkRsEKmX+ZGRjiGr4wwp3pqdxuLCRHeqW_H0x9Q@mail.gmail.com>
	<CA+icZUVAP4ArN+j34GTUwMxte5DtLPJSrLmK9T6Na8Qy+aM0Rg@mail.gmail.com>
	<20130121140738.GI5588@quack.suse.cz>
	<CA+icZUXLcdnNPvA9o8d5msOQ0MkMci8mPXujLZ3zcYjYcVZ7JQ@mail.gmail.com>
	<20130121231130.GB12410@thunk.org>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Sedat Dilek <sedat.dilek@gmail.com>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>, mszeredi@suse.cz
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20130121231130.GB12410@thunk.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 22, 2013 at 12:11 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jan 22, 2013 at 12:04:32AM +0100, Sedat Dilek wrote:
>>
>> Beyond the FUSE/LOOP fun, will you apply this patch to your linux-next GIT tree?
>>
>> Feel free to add...
>>
>>      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>>
>> A similiar patch for JBD went through your tree into mainline (see [1] and [2]).
>
> I'm not at all convinced that this patch has anything to do with your
> problem.  I don't see how it could affect things, and I believe you
> mentioned that you saw the problem even with this patch applied?  (I'm
> not sure; some of your messages which you sent were hard to
> understand, and you mentioned something about trying to send messages
> when low on sleep :-).
>

Even with little sleep I know what I have written.
YES, it didn't fix my problem but it also did not hurt my system.
I just run Linux Test Project w/o errors which also means nothing.
( Hmmm, I checked-out xfstests... did I compile it :-)? )

> In any case, the reason why I haven't pulled this patch into the ext4
> tree is because I was waiting for Eric and some of the performance
> team folks at Red Hat to supply some additional information about why
> this commit was making a difference in performance for a particular
> proprietary, closed source benchmark.
>

I am not following the linux-ext4/linux-fsdevel MLs so much, but IIRC
this patch is from December 2012.
An identical patch for JBD (approx. from same date) went upstream,
that's why I asked.
But now I know you care of JBD2 stuff :-).
Of course, I leave it to the experts to decide.
Come on Eric, open the pandora box and bomb Ted with logs and traces :-).

> I'm very suspicious about applying patches under the "cargo cult"
> school of programming.  ("We don't understand why it makes a
> difference, but it seems to be good, so bombs away!" :-)
>

A good attitude - a man we can trust!

I would liked to see a more positive development on my issue.
But I still see no real reason to throw this WUBI installation away
hitting a "corner" case.
It was done as a temporary installation and made me happy in my daily
working life.
If I will get unhappy I boot into Win7, oops.

- Sedat -

> Regards,
>
>                                         - Ted
