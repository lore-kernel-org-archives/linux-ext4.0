From: Peter Stuge <stuge-linux-pcmcia@cdy.org>
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Date: Fri, 11 Jan 2008 04:09:45 +0100
Message-ID: <20080111030945.27954.qmail@cdy.org>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx>
	<477E379F.4000103@student.ltu.se>
	<20080105041228.GP3351@webber.adilger.int>
	<20080105051817.GD27894@ZenIV.linux.org.uk>
	<4786883E.30604@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>, akpm@linux-foundation.org,
	Mathieu Segaud <mathieu.segaud@regala.cx>
To: Roel Kluin <12o3l@tiscali.nl>
Return-path: <linux-pcmcia-bounces+glkpd-linux-pcmcia=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <4786883E.30604@tiscali.nl>
List-Unsubscribe: <http://lists.infradead.org/mailman/listinfo/linux-pcmcia>,
	<mailto:linux-pcmcia-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-pcmcia>
List-Post: <mailto:linux-pcmcia@lists.infradead.org>
List-Help: <mailto:linux-pcmcia-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-pcmcia>,
	<mailto:linux-pcmcia-request@lists.infradead.org?subject=subscribe>
Sender: linux-pcmcia-bounces@lists.infradead.org
Errors-To: linux-pcmcia-bounces+glkpd-linux-pcmcia=m.gmane.org+glkpd-linux-pcmcia=m.gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 10, 2008 at 10:03:58PM +0100, Roel Kluin wrote:
> -#define DEBUG(x,args...)	printk(__FUNCTION__ ": " x,##args)
> +#define DEBUG(x, args...)	printk("%s: ", __func__, x, ##args)

Can this really be expected to work when x contains conversions?

How about:

#define DEBUG(x, args...) printk("%s: " x, __func__, ##args)


//Peter
