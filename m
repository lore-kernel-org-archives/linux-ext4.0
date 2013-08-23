From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 0/5] Rework mtime and ctime updates on mmaped writes
Date: Thu, 22 Aug 2013 18:12:28 -0700
Message-ID: <5216B6FC.5050908@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
	Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
	Christoph Hellwig <hch@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/22/2013 05:03 PM, Andy Lutomirski wrote:
> Writes via mmap currently update mtime and ctime in ->page_mkwrite.

The subject should be [PATCH v4 0.7]...  Sorry for the cut-and-pasteo.

--Andy
