From: Thomas Bushnell BSG <tb@becket.net>
Subject: Re: Future of ext2 support in the Hurd?
Date: Tue, 14 Aug 2007 20:41:20 -0400
Message-ID: <1187138480.9413.35.camel@localhost>
References: <E1IKLAG-0002yi-8Z@candygram.thunk.org>
	<878x8g5mkc.wl%marcus.brinkmann@ruhr-uni-bochum.de>
	<20070813162135.GC28130@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: bug-hurd@gnu.org, linux-ext4@vger.kernel.org,
	Marcus Brinkmann <marcus.brinkmann@ruhr-uni-bochum.de>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <bug-hurd-bounces+gnu-bug-hurd=m.gmane.org@gnu.org>
In-Reply-To: <20070813162135.GC28130@thunk.org>
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/bug-hurd>,
	<mailto:bug-hurd-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/pipermail/bug-hurd>
List-Post: <mailto:bug-hurd@gnu.org>
List-Help: <mailto:bug-hurd-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/bug-hurd>,
	<mailto:bug-hurd-request@gnu.org?subject=subscribe>
Sender: bug-hurd-bounces+gnu-bug-hurd=m.gmane.org@gnu.org
Errors-To: bug-hurd-bounces+gnu-bug-hurd=m.gmane.org@gnu.org
List-Id: linux-ext4.vger.kernel.org

Currently the plan (approved by RMS) is to keep the Hurd libraries at
"GPLv2 or any later version" so that they can be linked with
Linux-derived code such as ext2fs stuff, and more importantly,
networking stuff.  The Hurd programs themselves (rather than just the
libraries) will be GPLv3, though the transition has not yet happened.

The particular programs that actually use GPLv2-only stuff (ext2fs,
pfinet) will remain as they are.

So thanks for the concern Ted!  It's an important issue, and one that we
think we have worked out correctly.

Thomas
