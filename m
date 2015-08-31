From: Raymond Jennings <shentino@gmail.com>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Mon, 31 Aug 2015 16:03:06 -0700
Message-ID: <55E4DD2A.60800@gmail.com>
References: <20150831061920.GA2751@quack.suse.cz>
 <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
 <55E4D5DE.2030709@gmail.com>
 <CA+55aFz+n6uE7hRB=2mxeLiaVK8qTwjfSU_f_sAMY7kK0AG0sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFz+n6uE7hRB=2mxeLiaVK8qTwjfSU_f_sAMY7kK0AG0sg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/31/15 15:39, Linus Torvalds wrote:
> On Mon, Aug 31, 2015 at 3:31 PM, Raymond Jennings <shentino@gmail.com> wrote:
>> That said, I wouldn't mind myself if the ext4 driver were given a very
>> grueling regression test to make sure it can actually handle old ext3
>> systems as well as the ext3 driver can.
> That's not my only worry. Things like "can you go back to ext3-only"
> is an issue too - I don't think that's been a big priority for ext4
> any more, and if there are any existing hold-outs that still use ext3,
> they may want to be able to go back to old kernels.
Then we should just consider anything making an ext3 system unusuable by 
older kernels as a regression to be stomped like any other.
> So it's not just a "you can use ext4 instead" issue. Can you do that
> *without* then forcing an upgrade forever on that partition? I'm not
> sure the ext4 people are really even willing to guarantee that kind of
> backwards compatibility.
Breaking that guarantee would be an example of such a regression.
> I could be ok with removing ext3 in theory, but I haven't seen a lot
> of rationale for it, and I don't know if there are still users who may
> have their own good reasons to stay with ext3. Maybe there has been
> lots of discussion about this on fsdevel (which I don't follow), and
> I'm just lacking the background, but if so I want to see that
> background. Not just a oneliner description that basically says
> "remove ext3 support".
I actually agree that removing support for ext3 as a filesystem is a bad 
idea.  That would be a regression.

What I'm in favor of is removing the ext3 code as redundant if ext4 code 
can handle everything.  Of course, for it to be truly redundant, the 
ext4 code has to actually be capable of managing an ext3 filesystem 
without bumping it out of compatibility with older ext3 kernels.  Any 
such bump would rightly be classified as a regression.
>                      Linus
