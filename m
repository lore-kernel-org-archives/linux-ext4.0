From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfstests: add new quota stress test
Date: Mon, 24 Oct 2011 05:14:13 -0400
Message-ID: <20111024091412.GA3557@infradead.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
 <1319020189-13584-9-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org,
	aelder@sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1319020189-13584-9-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Same comment about the subject as the previous one.

Also please use su as xfstest currently doesn't use and require sudo.

Also please use $qa_user instead of using fsgqa directly.

