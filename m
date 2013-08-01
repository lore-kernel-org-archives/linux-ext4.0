From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: Implement FALLOC_FL_COLLAPSE_RANGE
Date: Thu, 1 Aug 2013 01:24:02 -0700
Message-ID: <20130801082402.GA23414@infradead.org>
References: <1375281734-15874-1-git-send-email-linkinjeon@gmail.com>
	<20130801011812.GJ7118@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Namjae Jeon <linkinjeon@gmail.com>, elder@kernel.org, tytso@mit.edu,
	Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org,
	bpm@sgi.com, adilger.kernel@dilger.ca, a.sangwan@samsung.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20130801011812.GJ7118@dastard>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

Instead of adding more mess to change_file_space it might be a good idea
to pull my

  "refactor the preallocation and hole punching code"

series from December in first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
