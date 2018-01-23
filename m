From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH v6 3/4] vfs: Add timestamp_truncate() api
Date: Tue, 23 Jan 2018 08:25:35 -0800
Message-ID: <CABeXuvogBWfTzteb8RFAGnW_HGLQX=hVUj0_SZ-TP1ZeNj=OHA@mail.gmail.com>
References: <20180122020426.2988-1-deepa.kernel@gmail.com> <20180122020426.2988-4-deepa.kernel@gmail.com>
 <CA+55aFyNbcS8k3x1WrZ1-Ymtr6OpnCJ8NUZXBUCfacwWXYzC+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        y2038 Mailman List <y2038@lists.linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyNbcS8k3x1WrZ1-Ymtr6OpnCJ8NUZXBUCfacwWXYzC+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 22, 2018 at 12:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Jan 21, 2018 at 6:04 PM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>> +               t.tv_nsec -= t.tv_nsec % gran;
>
> This doesn't actuall ywork if tv_nsec is negative.

Right.

> Which may not be an issue in most cases, but did somebody check
> utimensat() or whatever?

I checked POSIX again. There is no mention of tv_nsec being positive
always for utimes.
And, the long term plan is to replace all the callers of
timespec_trunc() to use this new api instead for filesystems.
So this will need to be fixed. I will fix this and post an update.

>> +               WARN(1, "illegal file time granularity: %u", gran);
>
> .. small nit: we generally should use 'invalid' rather than 'illegal'.

Will update this as well.

Thanks,
Deepa
