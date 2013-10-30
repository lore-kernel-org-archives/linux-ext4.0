From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: pair trace_ext4_writepages &
 trace_ext4_writepages_result
Date: Wed, 30 Oct 2013 07:36:03 -0400
Message-ID: <20131030113603.GA12186@thunk.org>
References: <1382012926-398-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Ming Lei <ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1382012926-398-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 17, 2013 at 08:28:46PM +0800, Ming Lei wrote:
> Pair the two trace events to make troubeshooting writepages
> easier, and it should be more convinient to write a simple script
> to parse the traces.

Applied, thanks!!

					- Ted
