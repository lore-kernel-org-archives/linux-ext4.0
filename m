From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Tue, 1 Sep 2015 07:52:33 -0500
Message-ID: <55E59F91.6020309@redhat.com>
References: <20150831061920.GA2751@quack.suse.cz>
 <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
 <55E4D5DE.2030709@gmail.com>
 <CA+55aFz+n6uE7hRB=2mxeLiaVK8qTwjfSU_f_sAMY7kK0AG0sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Raymond Jennings <shentino@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFz+n6uE7hRB=2mxeLiaVK8qTwjfSU_f_sAMY7kK0AG0sg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 8/31/15 5:39 PM, Linus Torvalds wrote:
> On Mon, Aug 31, 2015 at 3:31 PM, Raymond Jennings <shentino@gmail.com> wrote:
>>
>> That said, I wouldn't mind myself if the ext4 driver were given a very
>> grueling regression test to make sure it can actually handle old ext3
>> systems as well as the ext3 driver can.
> 
> That's not my only worry. Things like "can you go back to ext3-only"
> is an issue too - I don't think that's been a big priority for ext4
> any more, and if there are any existing hold-outs that still use ext3,
> they may want to be able to go back to old kernels.

Others have said it as well, but I'll restate: Yes, you can go "back."

But there's no real "going back" needed, because mounting an ext3
filesystem with ext4.ko hasn't "gone anywhere."  If you use ext4.ko,
you are running with a newer driver, but not a newer disk format.

> So it's not just a "you can use ext4 instead" issue. Can you do that
> *without* then forcing an upgrade forever on that partition? I'm not
> sure the ext4 people are really even willing to guarantee that kind of
> backwards compatibility.

Yeah, we are, I think I remember making an explicit stink about that quite
a while ago.  But I'm satisfied; we do use CONFIG_EXT4_USE_FOR_EXT23
in RHEL7, and we wouldn't do that if it might change disk format
behind our users' backs.

And it really is transparent; ext3 still shows up in /proc/filesystems,
and /proc/mounts still tells you you've mounted with ext3.

So yes, you can go back to 2.6.16 and mount it with the old ext3 driver,
if you like.

> I could be ok with removing ext3 in theory, but I haven't seen a lot
> of rationale for it, and I don't know if there are still users who may
> have their own good reasons to stay with ext3. Maybe there has been
> lots of discussion about this on fsdevel (which I don't follow), and
> I'm just lacking the background, but if so I want to see that
> background. Not just a oneliner description that basically says
> "remove ext3 support".

Yeah, the rationale is just about maintainability.  It makes little sense
to maintain a fairly large but separate codebase, when that old codebase
is just a subset of a newer, more actively maintained codebase.
And when most major distros have stopped using it, that old codebase
is going to do nothing but get crufty.

FWIW, this has been the plan all along, even though the timeline was just
a tad optimistic. [1] ;)

-Eric

[1] http://lwn.net/Articles/189950/

"At that point, perhaps 12-18 months out, we may request that the code in
fs/ext3/*.c be deleted and that fs/ext4 register itself as supporting the
ext3 filesystem as well."  -- tytso, June 2006 ;)

>                     Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

