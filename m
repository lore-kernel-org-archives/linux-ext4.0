From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5.1 00/14] crc32c: Add faster algorithm and self-test
 code
Date: Wed, 30 Nov 2011 14:29:11 -0800
Message-ID: <20111130142911.673c2d99.akpm@linux-foundation.org>
References: <20111128223659.28705.56719.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	Theodore Tso <tytso@mit.edu>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111128223659.28705.56719.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 28 Nov 2011 14:36:59 -0800
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> This patchset (re)uses Bob Pearson's crc32 slice-by-8 code to stamp out a
> software crc32c implementation.

I think the attributions here are all messed up.  As the patches stand,
it appears that you wrote all of them.  But I don't think that is the
case.

If Bob wrote a particular patch then that patch should be sent with a
From: Bob Pearson <rpearson@systemfabricworks.com> right at the start
of the changelog so that he is recorded as the primary author.  If the
email sender (ie: you) was the primary author then this attribution can
be omitted and we fall back to using the From: from the email headers.

Also, every one of these patches should have you own signed-off-by,
regardless of its authorship.  For reasons explained in
Documentation/SubmittingPatches, section 12.

Please fix these things up and resend.

Also, it would be conventional and useful if each patch title was
prefixed by its subsystem identifier.  ie, "removed two instances of
trailing whitespaces" should be titled "crc32: remove two instances of
trailing whitespace" or "lib/crc32.c: remove two instances of trailing
whitespaces".

