From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/ data=journal
Date: Mon, 05 Oct 2015 13:49:41 -0700
Message-ID: <B602A991-01B4-42E7-AF13-1E21DFB714F8@zytor.com>
References: <20151005152236.GA8140@thunk.org> <CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com> <5612A3F3.2040609@linux.intel.com> <CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On October 5, 2015 1:22:44 PM PDT, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>We could probably do them outside the loop, rather than tightly around
>the actual move instructions. Peter (hpa), is there some sane
>interface to try to do that?

There are... in particular the get_user_try/catch mechanism, used among other things by the signal handing, as well as the copy functions (I don't have the original code in front of me so I don't have the context which would be appropriate.)


-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
