From: Dave Jones <davej@redhat.com>
Subject: Re: [GIT PULL URGENT] ext4 regression fix for 3.9
Date: Thu, 28 Feb 2013 22:30:05 -0500
Message-ID: <20130301033005.GA7081@redhat.com>
References: <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185625.GA224@x4>
 <20130227191923.GA1121@redhat.com>
 <20130227192907.GB14253@thunk.org>
 <20130227201217.GD14253@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130227201217.GD14253@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 27, 2013 at 03:12:17PM -0500, Linus Torvalds wrote:
 > The following changes since commit 304e220f0879198b1f5309ad6f0be862b4009491:
 > 
 >   ext4: fix free clusters calculation in bigalloc filesystem (2013-02-22 15:27:52 -0500)
 > 
 > are available in the git repository at:
 > 
 >   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus
 > 
 > for you to fetch changes up to 8e919d13048cd5acaadb2b15b48acbfb8832d3c2:
 > 
 >   ext4: fix extent status tree regression for file systems > 512GB (2013-02-27 14:54:37 -0500)
 > 
 > ----------------------------------------------------------------
 > This fixes a real brown paper bag bug which causes ext4 to choke on
 > file systems larger than 512GB.
 > 
 > ----------------------------------------------------------------
 > Theodore Ts'o (1):
 >       ext4: fix extent status tree regression for file systems > 512GB
 > 
 >  fs/ext4/extents_status.h | 19 +++++++++++--------
 >  1 file changed, 11 insertions(+), 8 deletions(-)

This has fixed the problem I reported, but I notice now that my desktop is really
sluggish. perf top shows it's almost constantly spinning in ext4_es_reclaim_extents_count

Any ideas ?

	Dave
