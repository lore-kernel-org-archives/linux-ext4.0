From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [RFC 0/6] vfs: Add timestamp range check support
Date: Sun, 6 Nov 2016 09:44:33 -0800
Message-ID: <CABeXuvoCANJohBWy4mpJFiYvJj0XNHKVpW1RWhXVrd9ZjT5FSQ@mail.gmail.com>
References: <1478099096-25637-1-git-send-email-deepa.kernel@gmail.com>
 <20161102224827.GJ14023@dastard> <20161103204357.r7lgvbsv3euujijn@thunk.org> <1206C36E-9CB4-47B3-A891-8EA94C3220E0@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        linux-afs@lists.infradead.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1206C36E-9CB4-47B3-A891-8EA94C3220E0@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I will post xfs tests that validate mount and range checking.
I will keep the policy same as what the RFC suggests for now.

Clamping can be verified once vfs is transitioned to using time64_t.

Thanks,
Deepa
