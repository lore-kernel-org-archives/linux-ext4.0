From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: regression test for ext4 resize with non-extent
	files
Date: Thu, 09 May 2013 22:05:56 -0500
Message-ID: <518C6414.20800@redhat.com>
References: <518C1D08.4080309@redhat.com>
	<CA+dCu8_DtrqMy97u9NfHwCC8_-z9uSrF1oR3B=ej15gL6C=W+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
To: guaneryu@gmail.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <CA+dCu8_DtrqMy97u9NfHwCC8_-z9uSrF1oR3B=ej15gL6C=W+Q@mail.gmail.com>
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

On 5/9/13 10:03 PM, Eryu Guan wrote:
> On Fri, May 10, 2013 at 6:02 AM, Eric Sandeen <sandeen@redhat.com <mailto:sandeen@redhat.com>> wrote:
> 

...

>     index 53af708..4c3e2f4 100644
>     --- a/tests/ext4/group
>     +++ b/tests/ext4/group
>     @@ -9,3 +9,4 @@
>      303 aio dangerous ioctl rw stress
>      304 aio dangerous ioctl rw stress
>      305 auto
>     +306 dangerous rw resize quick
> 
> 
> I'm wondering why it's not in auto group :)


because I forgot about auto! :)

But it's also somewhat dangerous; it could oops or hang, so perhaps
auto is not a good idea.

-Eric


> Otherwise patch looks good to me.
> 
> Eryu Guan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
