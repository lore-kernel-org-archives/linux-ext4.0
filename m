From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] ext4: Add fdatasync scalability optimization
Date: Tue, 14 Oct 2014 03:57:29 -0700
Message-ID: <20141014105729.GA19981@infradead.org>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
 <1413281035-6483-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413281035-6483-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Much of the bookkeeping here seems generic and should be in common
code and not inside a filesystem.
