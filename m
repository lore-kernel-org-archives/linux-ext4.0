From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] docs: fix some broken documentation references
Date: Thu, 20 Sep 2018 11:10:22 -0600
Message-ID: <20180920111022.072b33a7@lwn.net>
References: <6b47bf56b898c48a0dc3cd42283c9e5c7c23367a.1537210894.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jan Kara <jack@suse.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6b47bf56b898c48a0dc3cd42283c9e5c7c23367a.1537210894.git.mchehab+samsung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 17 Sep 2018 15:02:34 -0400
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:

> Some documentation files received recent changes and are
> pointing to wrong places.
> 
> Those references can easily fixed with the help of a
> script:
> 
> 	$ ./scripts/documentation-file-ref-check --fix
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Applied, thanks.

jon
