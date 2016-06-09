From: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 01/21] fs: Replace CURRENT_TIME_SEC with current_fs_time()
Date: Thu, 9 Jun 2016 08:31:10 -0400
Message-ID: <20160609123110.GB31287@localhost>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
 <1465448705-25055-2-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	y2038@lists.linaro.org, Artem Bityutskiy <dedekind1@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	linux-mtd@lists.infradead.org,
	Evgeniy Dushistov <dushistov@mail.ru>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	linux-afs@lists.infradead.org,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Jan Harkes <jaharkes@cs.cmu.edu>,
	coda@cs.cmu.edu, codalist@coda.cs.cmu.edu,
	linux-karma-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465448705-25055-2-git-send-email-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 08, 2016 at 10:04:45PM -0700, Deepa Dinamani wrote:
> CURRENT_TIME_SEC is not y2038 safe. current_fs_time() will
> be transitioned to use 64 bit time along with vfs in a
> separate patch.
> There is no plan to transistion CURRENT_TIME_SEC to use
> y2038 safe time interfaces.

[...]

> Cc: Bob Copeland <me@bobcopeland.com>

OMFS parts look sane, thanks.

-- 
Bob Copeland %% http://bobcopeland.com/
