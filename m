From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 bug fixes for 4.6
Date: Mon, 11 Apr 2016 21:28:15 -0400
Message-ID: <20160412012815.GF7369@thunk.org>
References: <xr93bn5iyzeq.fsf@gthelen.mtv.corp.google.com>
 <CA+55aFwdgD1Y7caKoL=8aPvoKUwObA-Fa8LypPBZMA87pBcu1w@mail.gmail.com>
 <CA+55aFzfmHptveL=y1C5VidQjjiSekcCq=-fg1Z-W6Szog-VRA@mail.gmail.com>
 <CA+55aFyGeZTy291E5jRkF63qBL=cRpLVw4FGzePZR7FhNUFp_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Thelen <gthelen@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyGeZTy291E5jRkF63qBL=cRpLVw4FGzePZR7FhNUFp_w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Linus,

Thanks for reverting the broken commit.  I'll work on a proper fix for
the readdir() issue for the next merge cycle, and make sure it gets
proper testing.

I'll also take care of packaging up Greg's test program and getting it
submitted to xfstests so we have a proper regression test case.

Cheers,

						- Ted
