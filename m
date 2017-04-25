From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5 2/5] vfs: Add checks for filesystem timestamp limits
Date: Tue, 25 Apr 2017 13:02:40 -0700
Message-ID: <CA+55aFzFWma+EMB-xQ7QBPbOzUOkSc0XEwy9DgLpYfVzMYJQGg@mail.gmail.com>
References: <1491680267-11171-1-git-send-email-deepa.kernel@gmail.com>
 <1491680267-11171-3-git-send-email-deepa.kernel@gmail.com>
 <CA+55aFymxtrw8tr6Q9vLrP7nJ5zOjShstpyQOxxr-m1Wkv9gNg@mail.gmail.com>
 <CABeXuvo6UyvV2yqcju+Mxh8Mmsihrpf209D8p+u68SV5nHf2-A@mail.gmail.com> <CAK8P3a002GSya0oxiLnJjDjcsfULSfmOTkf=JMTJEaV0a=dKjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a002GSya0oxiLnJjDjcsfULSfmOTkf=JMTJEaV0a=dKjQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 25, 2017 at 12:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> There is one global option that I want to see, and that is for completely
> disabling all components that are known to be broken in y2038.

I really don't see the point.

Don't do it. Make it some local hack, I'm not taking crazy patches.

                    Linus
