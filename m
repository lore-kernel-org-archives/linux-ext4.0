From: Raymond Jennings <shentino@gmail.com>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Mon, 31 Aug 2015 15:31:58 -0700
Message-ID: <55E4D5DE.2030709@gmail.com>
References: <20150831061920.GA2751@quack.suse.cz>
 <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/31/15 14:37, Linus Torvalds wrote:
> On Sun, Aug 30, 2015 at 11:19 PM, Jan Kara <jack@suse.cz> wrote:
>> The biggest change in the pull is the removal of ext3 filesystem driver
>> (~28k lines removed).
> I really am not ready to just remove ext3 without a lot of good
> arguments. There might well be people who this use ext3 as ext3, and
> don't want to update. I want more a rationale for removal than "ext4
> can read old ext3 filesystems".
I actually would agree that having two drivers for the same filesystem 
is redundant and unneeded code duplication.

That said, I wouldn't mind myself if the ext4 driver were given a very 
grueling regression test to make sure it can actually handle old ext3 
systems as well as the ext3 driver can.  Just gutting an entire driver 
because another driver can handle it only makes sense if nothing can go 
wrong and the potential for causing regressions is quite obvious.

I think also that we should remove the ext2 driver before we remove the 
ext3 driver.

My two cents.
>                    Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
