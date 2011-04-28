From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback
 related.
Date: Thu, 28 Apr 2011 17:44:39 -0500
Message-ID: <1304030679.2598.43.camel@mulgrave.site>
References: <1303926637.2583.17.camel@mulgrave.site>
	 <1303934716.2583.22.camel@mulgrave.site> <1303990590.2081.9.camel@lenovo>
	 <1303993705-sup-5213@think> <1303998140.2081.11.camel@lenovo>
	 <1303998300-sup-4941@think> <1303999282.2081.15.camel@lenovo>
	 <20110428142551.GD1696@quack.suse.cz> <20110428143329.GE1696@quack.suse.cz>
	 <1304002701.2081.21.camel@lenovo>  <20110428224038.GG1696@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Colin Ian King <colin.king@ubuntu.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, mgorman@novell.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110428224038.GG1696@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2011-04-29 at 00:40 +0200, Jan Kara wrote:
> James in the meantime identified that cgroups are somehow involved.
> Are you
> using systemd by any chance? Maybe cgroup IO throttling screws us?

Yes, this is a FC15 system with systemd as the default.

See related post: it looks like disabling the memory controller is what
makes this go away.

James
